context "non-admin users (projec viewers)" do 
    before do 
        login_as(user)
        assign_role!(user, :viewer, project)
    end
end 