# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController do
  let(:valid_attributes) { attributes_for(:product) }

  let(:invalid_attributes) { attributes_for(:product, :invalid_attributes) }

  let!(:product) { create(:product) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_successful
      expect(assigns(:products)).to eq([product])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: product.to_param }
      expect(response).to be_successful
      expect(assigns(:product)).to eq(product)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new product' do
        expect do
          post :create, params: { product: valid_attributes }
        end.to change(Product, :count).by(1)
      end

      it 'redirects to the created product' do
        post :create, params: { product: valid_attributes }
        expect(response).to redirect_to(Product.last)
      end
    end

    context 'with invalid params' do
      it 'does not create a new product' do
        expect do
          post :create, params: { product: invalid_attributes }
        end.not_to change(Product, :count)
      end

      it 'renders the new template' do
        post :create, params: { product: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:product) { Product.create!(valid_attributes) }

    it 'destroys the requested product' do
      expect do
        delete :destroy, params: { id: product.id }
      end.to change(Product, :count).by(-1)
    end

    it 'redirects to index with notice on successful deletion' do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_url)
      expect(flash[:notice]).to eq("Product was successfully destroyed.")
    end

    it 'redirects back with an error message if deletion fails' do
      allow_any_instance_of(Product).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_url)
    end
  end
end
