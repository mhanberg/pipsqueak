"<!DOCTYPE html>"
html lang: "en" do
  head do
    meta charset: "utf-8"
    meta http_equiv: "X-UA-Compatible", content: "IE=edge"
    meta name: "viewport", content: "width=device-width, initial-scale=1.0"
    title do
      assigns[:page_title] || "Pipsqueak · Phoenix Framework"
    end
    link rel: "stylesheet", href: Routes.static_path(@conn, "/css/app.css")
    link href: "https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css", rel: "stylesheet"

    csrf_meta_tag()
  end

  body do
    header do
      section class: "container" do
        nav role: "navigation" do
          ul do
            li do
              a href: "https://hexdocs.pm/phoenix/overview.html" do
                "Get Started"
              end
            end
          end
        end
        a href: "https://phoenixframework.org/", class: "phx-logo" do
          img src: Routes.static_path(@conn, "/images/phoenix.png"), alt: "Phoenix Framework Logo"
        end
      end
    end
    main role: "main", class: "container" do
      p class: "alert alert-info", role: "alert" do
        get_flash(@conn, :info)
      end
      p class: "alert alert-danger", role: "alert" do
        get_flash(@conn, :error)
      end

      render @view_module, @view_template, assigns
    end

    script type: "text/javascript", src: Routes.static_path(@conn, "/js/app.js")
  end
end
