require "rails_helper"

RSpec.describe Admin::UsersController, type: :controller do
  let(:valid_params) {FactoryBot.attributes_for :user, description: "blabla"}
  let(:invalid_params) {FactoryBot.attributes_for :user, email: nil}
  let!(:user) {FactoryBot.create :user}
  let!(:user) {FactoryBot.create :user, role: :admin}
  let!(:user_two) {FactoryBot.create :user}
  let!(:user_three) {FactoryBot.create :user}

  before {login user}

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "renders the 'index' template" do
      expect(response).to render_template :index
    end

    it "assigns @users" do
      expect(assigns(:users).pluck(:id)).to eq [user.id, user_two.id, user_three.id]
    end
  end

  describe "GET #edit" do
    context "when valid params" do
      before {get :edit, params: {id: user.id}}

      it "should have a valid user" do
        expect(assigns(:user).id).to eq user.id
      end
    end

    context "when invalid params" do
      before {get :edit, params: {id: "string"}}

      it "should have a invalid user" do
        expect(assigns(:user)).to eq nil
      end
    end
  end

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update, params: {id: user.id, user: {email: "test_email@gmail.com"}}}

      it "should correct name" do
        expect(assigns(:user).email).not_to eq "test_email@gmail.com"
      end

      it "should redirect admin_users_path" do
        expect(response).to redirect_to admin_users_path
      end
    end

    context "when invalid params" do
      before { patch :update, params: {id: user.id, user: invalid_params} }

      it "should a invalid user" do
        expect(assigns(:user).invalid?).to eq true
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end
  end
end
