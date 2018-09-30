module HasTodos
    extend ActiveSupport::Concern

    included do
        has_many :todos

        # Worker/parent relations
        has_many :todo_completes,                                    foreign_key: 'submitter_id', dependent: :destroy
        has_many :task_completes,                                    through: :todo_completes, dependent: :destroy
        has_many :sub_task_completes,                                through: :task_completes, dependent: :destroy
        has_many :completed_todo_completes,                          -> { where.not(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :completed_recurring_todo_completes,                -> { where.not(completion_date: nil).includes(:todo).where(todos: { iteration_type: 1} ) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :incomplete_todo_completes,                         -> { where.not(id: nil).where(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :completed_todos,                                  -> { includes(:todo_completes).where.not(todo_completes: { completion_date: nil } ) }, class_name: 'Todo'
        has_many :incomplete_todos,                                 -> { includes(:todo_completes).where.not(todo_completes: { id: nil } ).where(todo_completes: { completion_date: nil } ) }, class_name: 'Todo'

        has_many :todo_destroys,                                    class_name: 'UserTodoDestroy'

        # Manager/admin relations
        has_many :local_todos,                                      through: :daycare
        has_many :global_todos,                                     through: :daycare

        scope :all_global_todos, ->(query='') {  
                                        joins("LEFT JOIN user_daycares ON user_daycares.user_id = users.id")
                                        .joins("LEFT JOIN departments ON departments.daycare_id = user_daycares.daycare_id")
                                        .joins("LEFT JOIN department_todos ON department_todos.department_id = departments.id")
                                        .joins("LEFT JOIN todos ON todos.id = department_todos.todo_id")
                                        .select("todos.*, department_todos.department_id, departments.name AS department_name, department_todos.todo_active")
                                        .where("todos.daycare_id is null")
                                        .where("todos.title LIKE :search", search: "%#{query}%")
                                    }

        scope :all_self_daycare_todos, ->(query='') {  
                                        joins("LEFT JOIN user_daycares ON user_daycares.user_id = users.id")
                                        .joins("LEFT JOIN departments ON departments.daycare_id = user_daycares.daycare_id")
                                        .joins("LEFT JOIN department_todos ON department_todos.department_id = departments.id")
                                        .joins("LEFT JOIN todos ON todos.id = department_todos.todo_id")
                                        .select("todos.*, department_todos.department_id, departments.name AS department_name, department_todos.todo_active ")
                                        .where("todos.daycare_id is not null")
                                        .where("todos.title LIKE :search", search: "%#{query}%")
                                    }

        scope :all_self_todos, ->(query='') {  
                                        joins("LEFT JOIN departments ON departments.id = users.department_id")
                                        .joins("LEFT JOIN department_todos ON department_todos.department_id = departments.id")
                                        .joins("LEFT JOIN todos ON todos.id = department_todos.todo_id")
                                        .select("todos.*, department_todos.department_id, departments.name AS department_name ")
                                        .where("todos.title LIKE :search", search: "%#{query}%")
                                    }

        scope :self_available_todos, ->(query='') {  
                                        joins("LEFT JOIN departments ON departments.id = users.department_id")
                                        .joins("LEFT JOIN department_todos ON department_todos.department_id = departments.id")
                                        .joins("LEFT JOIN todos ON todos.id = department_todos.todo_id")
                                        .joins("LEFT JOIN (SELECT id, todo_id FROM todo_completes WHERE todo_completes.completion_date IS NULL AND todo_completes.status = 0 GROUP BY todo_completes.id) todo_completes ON todo_completes.todo_id = todos.id")
                                        .select("todos.*")
                                        .where("todo_completes.todo_id IS NULL")
                                        .where("department_todos.todo_active = true")
                                        .where("todos.title LIKE :search", search: "%#{query}%")
                                        .group("todos.id")
                                    }

        scope :self_incomplete_todos, ->(query='') {  
                                        joins("LEFT JOIN departments ON departments.id = users.department_id")
                                        .joins("LEFT JOIN department_todos ON department_todos.department_id = departments.id")
                                        .joins("LEFT JOIN todos ON todos.id = department_todos.todo_id")
                                        .joins("LEFT JOIN todo_completes ON todo_completes.todo_id = todos.id AND todo_completes.completion_date IS NULL")
                                        .select("todos.*, todo_completes.id AS tc_id")
                                        .where("todo_completes.todo_id IS NOT NULL")
                                        .where("department_todos.todo_active = true")
                                        .where("todos.title LIKE :search", search: "%#{query}%")
                                        .group("todos.id, todo_completes.id")
                                    }

        # scope :self_incomplete_todos, ->(query='') {  
        #                                 joins("LEFT JOIN departments ON departments.id = users.department_id")
        #                                 .joins("LEFT JOIN department_todos ON department_todos.department_id = departments.id")
        #                                 .joins("LEFT JOIN todos ON todos.id = department_todos.todo_id")
        #                                 .joins("LEFT JOIN todo_completes ON todo_completes.todo_id = todos.id AND todo_completes.completion_date IS NULL")
        #                                 .select("todos.*, todo_completes.id AS tc_id")
        #                                 .where("todo_completes.todo_id IS NOT NULL")
        #                                 .where("department_todos.todo_active = true")
        #                                 .where("todos.title LIKE :search", search: "%#{query}%")
        #                                 .group("todos.id, todo_completes.id")
        #                             }

        scope :all_user_todos, ->(query='') {  
                                        joins("LEFT JOIN user_daycares ON user_daycares.user_id = users.id")
                                        .joins("LEFT JOIN todos ON (todos.daycare_id = user_daycares.daycare_id OR todos.daycare_id is null)")
                                        .select("todos.*")
                                        .where("todos.title LIKE :search", search: "%#{query}%")
                                        .order('todos.created_at')
                                    }
        scope :all_self_department_todos, ->(query='') {  
                                        joins("LEFT JOIN user_daycares ON user_daycares.user_id = users.id")
                                        .joins("LEFT JOIN departments ON departments.daycare_id = user_daycares.daycare_id")
                                        .joins("LEFT JOIN department_todos ON department_todos.department_id = departments.id")
                                        .joins("LEFT JOIN todos ON todos.id = department_todos.todo_id")
                                        .select("todos.*, department_todos.department_id, departments.name AS department_name, department_todos.todo_active")
                                        .where("todos.title LIKE :search", search: "%#{query}%")
                                    }

        # => Sets the available todos for a user
        #
        def available_todos
            all_todos.reject{|t| unavailable_todos.map(&:todo_id).include? t.id }
        end

        # => Sets the unavailable todos for a user
        #
        def unavailable_todos
            (completed_recurring_todo_completes.active + incomplete_todo_completes.active)
        end

        def all_todos
            daycare.all_todos.reject{|dt| daycare.todo_destroys.map(&:todo_id).include? (dt.id) }
        end
    end
end
