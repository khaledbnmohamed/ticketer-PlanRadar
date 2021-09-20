# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
RSpec.describe '/api/v1/users/user_id/tickets/ticket_id/' do
  path '/api/v1/users/{user_id}/tickets/{ticket_id}/tickets' do
    post 'create ticket' do
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id, in: :path, type: :integer, required: true
      parameter name: :ticket_id, in: :path, type: :integer, required: true

      parameter name: :ticket, in: :body, schema: {
        type: :object,
        properties: {
          ticket_price: { type: :string },
          user_id: { type: :string }

        }
      }
      response '200', 'create ticket succefully' do
        let(:user) { FactoryBot.create(:user) }
        let(:ticket) { FactoryBot.create(:ticket, creator: user, title: 'My ticket') }

        it 'create ticket succsfully' do
          post "/api/v1/users/#{user.id}/tickets",
               params: {
                 ticket: {
                   title: 'First ticket',
                   description: 'desc',
                   due_date: '1-1-2025',
                   status: 'pending'
                 }
               }
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['title']).to eq('First ticket')
          expect(response.parsed_body['description']).to eq('desc')
          expect(user.tickets.count).to eq 1
        end

        it 'delets ticket succsfully' do
          delete "/api/v1/users/#{user.id}/tickets/#{ticket.id}"
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['title']).to eq('My ticket')
          expect(user.tickets.count).to eq 0
        end

        it 'list all tickets succeffully' do
          FactoryBot.create_list(:ticket, 8, creator: user)

          get "/api/v1/users/#{user.id}/tickets"
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['tickets'].count).to eq(8)
        end
      end
    end
  end

  path '/api/v1/users/{user_id}/tickets/{ticket_id}/subtickets' do
    get 'list all sub ticket' do
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_id, in: :path, type: :integer, required: true
      parameter name: :ticket_id, in: :path, type: :integer, required: true

      response '200', 'create ticket succefully' do
        let(:user) { FactoryBot.create(:user) }
        let(:ticket) { FactoryBot.create(:ticket, creator: user, title: 'My ticket') }

        it 'list all subticket succeffully' do
          FactoryBot.create_list(:subticket, 15, parent: ticket)

          get "/api/v1/users/#{user.id}/tickets/#{ticket.id}/subticket"
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['tickets'].count).to eq(15)
        end
      end
    end
  end
end
