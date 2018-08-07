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

context "admin users" do 
        scenario "can see the Edit Project link" do 
            visit project_path(project)
            expect(page).to have_link "Edit Project"
        end 
end 