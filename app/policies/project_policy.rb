class ProjectPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        return scope.none if user.nil?
        return scope.all if user.admin? 

        scope.joins(:roles).where(roles: {user_id: user})
      end
    end

    def show? 
      user.try(:admin?) || record.roles.exists?(user_id: user)
    end 

    def update?
      user.try(:admin?) || record.roles.exists?(user_id: user, 
      role: 'manager')
    end

      context "permissions" do
        subject { ProjectPolicy.new(user, project) }

        let(:user) { FactoryGirl.create(:user) }
        let(:project) { FactoryGirl.create(:project) }
        
        context "for anonymous users" do
          let(:user) { nil }
          it { should_not permit_action :show }
          it { should_not permit_action :update }
        end

        context "for viewers of the project" do
          before { assign_role!(user, :viewer, project) }
          it { should permit_action :show }
          it { should_not permit_action :update }
        end

        context "for editors of the project" do
          before { assign_role!(user, :editor, project) }
          it { should permit_action :show }
          it { should_not permit_action :update }
        end

        context "for managers of the project" do
          before { assign_role!(user, :manager, project) }

          it { should permit_action :show }
          it { should permit_action :update }
        end

        context "for managers of other projects" do
          before do
            assign_role!(user, :manager, FactoryGirl.create(:project))
          end

          it { should_not permit_action :show }
          it { should_not permit_action :update }
        end

        context "for administrators" do
          let(:user) { FactoryGirl.create :user, :admin }

          it { should permit_action :show }
          it { should permit_action :update }
        end
      end
end
