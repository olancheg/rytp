module AdminHelper
  def role_selection(user)
    (all_roles.map do |role|
      content_tag :div, :class => 'field' do
        check_box_tag('user[role_ids][]', role.id, user.has_role?(role.name), :id => "user_roles_#{role.name}") +
        label_tag("user_roles_#{role.name}", t(:"roles.#{role.name}"))
      end
    end.join + hidden_field_tag('user[role_ids][]', '')).html_safe
  end
end
