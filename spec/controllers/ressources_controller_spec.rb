require 'rails_helper'

RSpec.describe Scalingo::ResourcesController do
  describe '#create' do
    login
    let(:create_params) { { uuid: 'uuid-1', options: {  } } }

    subject { post(:create, params: create_params) }

    it 'should send a valid response' do
      subject
      expect(response).to have_http_status 202
      body = JSON.parse response.body
      expect(body['id']).to eq 'uuid-1'
      expect(body['message']).to eq 'Addon is being provisioned'
    end
  end

  describe 'resume' do
    login
    let(:resume_params) { { resource_id: 'uuid' } }
    subject { post(:resume, params: resume_params) }

    it 'should send a valid response' do
      subject
      expect(response).to have_http_status :no_content
    end
  end

  describe '#suspend' do
    login
    let(:suspend_params) { { resource_id: 'uuid' } }
    subject { post(:suspend, params: suspend_params) }

    it 'should send a valid response' do
      subject
      expect(response).to have_http_status :no_content
    end
  end

  describe '#update' do
    login
    let(:update_params) { { id: 'uuid', plan: 'new-plan', options: { } } }
    subject { patch(:update, params: update_params) }

    it 'should send a valid response' do
      subject
      expect(response).to have_http_status 200
      body = JSON.parse response.body
      expect(body['message']).to eq 'Plan changed'
    end
  end

  describe '#destroy' do
    login
    let(:destroy_params) { { id: 'uuid' } }
    subject { delete(:destroy, params: destroy_params) }

    it 'should return a valid response' do
      subject
      expect(response).to have_http_status :no_content
    end
  end
end
