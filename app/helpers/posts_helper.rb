module PostsHelper
  def format_company_name_and_symbol(post)
    icon = get_all_post_types[post.post_type]
    result = icon + post.company.name
    return result.html_safe
  end

  def format_type_name_and_symbol(post_type)
    icon = get_all_post_types[post_type]
    result = icon + post_type
    return result.html_safe
  end

  def get_all_post_types
    post_types = {'Interview' => '<i class="fa fa-fw fa-newspaper-o"></i>',
                  'Case Study' => '<i class="fa fa-fw fa-list"></i>',
                  'Facebook' => '<i class="fa fa-fw fa-facebook-official"></i>',
                  'Twitter' => '<i class="fa fa-fw fa-twitter"></i>',
                  'LinkedIn' => '<i class="fa fa-fw fa-linkedin-square"></i>',
                  'Instagram' => '<i class="fa fa-fw fa-instagram"></i>',
                  'Blog Post' => '<i class="fa fa-fw fa-wordpress"></i>',
                  'White Paper' => '<i class="fa fa-fw fa-file-o"></i>',
                  'Ebook' => '<i class="fa fa-fw fa-book"></i>',
                  'Slidedeck' => '<i class="fa fa-fw fa-map-o"></i>',
                  'Video' => '<i class="fa fa-fw fa-video-camera"></i>',
                  'Podcast' => '<i class="fa fa-fw fa-microphone"></i>'
                }
  end
end
