class Hybridge::InstallGenerator < Rails::Generators::Base
  def inject_routes
    insert_into_file "config/routes.rb", after: ".draw do" do
      %(\n  mount Hybridge::Engine => '/hybridge'\n)
    end
  end

  def inject_dashboard_link
    file_path = "app/views/hyrax/dashboard/_sidebar.html.erb"
    if File.file?(file_path)
      insert_into_file file_path, after: /menu\.nav_link\(hyrax\.my_works_path.*?<% end %>/m do
        "\n\n  <%= menu.nav_link(hybridge.root_path,\n" \
        "                        also_active_for: hyrax.dashboard_works_path) do %>\n" \
        "    <span class=\"fa fa-magic\"></span> <span class=\"sidebar-action-text\"><%= t('hybridge.admin.sidebar.ingest') %></span>\n" \
        "  <% end %>\n"
      end
    else
      hyrax_path = Bundler.rubygems.find_name('hyrax').first.full_gem_path
      sidebar_path = hyrax_path + '/app/views/hyrax/dahsboard/_sidebar.html.erb'
      dest_folder = 'app/views/hyrax/dashboard/'
      FileUtils.cp(sidebar_path, dest_folder)
    end
  end

end
