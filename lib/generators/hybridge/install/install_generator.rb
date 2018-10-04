class Hybridge::InstallGenerator < Rails::Generators::Base
  def inject_routes
    insert_into_file "config/routes.rb", after: ".draw do" do
      %(\n  mount Hybridge::Engine => '/hybridge'\n)
    end
  end

  def inject_dashboard_link
    file_path = 'app/views/hyrax/dashboard/_sidebar.html.erb'
    hyrax_path = Bundler.rubygems.find_name('hyrax').first.full_gem_path
    menu_path = hyrax_path + '/app/views/hyrax/dashboard/sidebar/_repository_content.html.erb'
    if File.file?(file_path)
      add_link(file_path)
    elsif File.file? menu_path
      dest_path = 'app/views/hyrax/dashboard/sidebar'
      dest_file = dest_path + '/_repository_content.html.erb'
      FileUtils.mkdir_p(dest_path)
      FileUtils.cp menu_path, dest_file
      add_link(dest_file)
    end
  end

  private

  def add_link(file_path)
    insert_into_file file_path, after: /menu\.nav_link\(hyrax\.my_works_path.*?<% end %>/m do
      "\n\n  <%= menu.nav_link(hybridge.root_path,\n" \
      "                        also_active_for: hyrax.dashboard_works_path) do %>\n" \
      "    <span class=\"fa fa-magic\"></span> <span class=\"sidebar-action-text\"><%= t('hybridge.admin.sidebar.ingest') %></span>\n" \
      "  <% end %>\n"
    end
  end

end
