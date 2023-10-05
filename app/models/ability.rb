# frozen_string_literal: true

# Below is implementaion of static authorization
# For dynamic authorization we can work on below points
#=> We can create roles table with attribute [:id, :name]
#=> We can create permissions table with attribute [:id, :subject_class, :action]
#=> permission to role association => has_and_belongs_to_many :roles
#=> role to permission association => has_and_belongs_to_many :permission
#=> create user and assign role
#=> And then based on user's role we will check authorization.
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user

    if user.admin?
      can :manage, :all
    elsif user.schooladmin?
      can %i[update show], School, user_id: user.id
      can :manage, Course
      can :manage, Batch, school_id: user.school.id
      can %i[update index], Enrollment, batch: { school: { user_id: user.id } }
    elsif user.student?
      can :read, School
      can :read, Course
      can %i[create index], Enrollment, user_id: user.id
      can :show_class_mates, Enrollment
      can :read, Batch
    end
  end
end
