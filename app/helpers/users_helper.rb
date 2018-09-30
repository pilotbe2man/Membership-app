module UsersHelper
  def options_for_roles_select
    {
      'Admin': 'admin',
      'Manager': 'manager',
      'Parentee': 'parentee',
      'Worker': 'worker'
    }
  end
end
