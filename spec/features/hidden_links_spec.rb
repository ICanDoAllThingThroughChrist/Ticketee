require "rails_helper" 
RSpec.feature "Users can view projects" do
    let(:user) { FactoryGirl.create(:user)}
    let(:project) {FactoryGirl.create(:project, name: "Sublime Text 3")}
    context "non-admin users (project viewers)" do 
        before do 
            login_as(user)
            assign_role!(user, :viewer, project)
        end

        scenario "cannot see the Edit Project link" do 
            visit project_path(project)
            expect(page).not_to have_link "Edit Project"
        end
    end 
end

context "admin users" do 
        scenario "can see the Edit Project link" do 
            visit project_path(project)
            expect(page).to have_link "Edit Project"
        end 
end 