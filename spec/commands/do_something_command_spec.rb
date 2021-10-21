# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DoSomethingCommand do
  describe '.call' do
    subject { described_class.call(execute_method_a: true, execute_method_b: true) }

    it { is_expected.to be_truthy }
  end

  describe '.call diffrent way' do
    subject { described_class.new(execute_method_a: execute_method_a, execute_method_b: execute_method_b) }
    let(:execute_method_a) {}
    let(:execute_method_b) {}

    after(:each) { subject.call }

    context 'when execute_method_a is true' do
      let(:execute_method_a) { true }

      it { expect(subject).to receive(:todo_method_a) }
    end

    context 'when execute_method_b is true' do
      let(:execute_method_b) { true }

      it { expect(subject).to receive(:todo_method_b) }
    end

    context 'when execute_method_a is false' do
      let(:execute_method_a) { false }

      it { expect(subject).to_not receive(:todo_method_a) }
    end

    context 'when execute_method_b is false' do
      let(:execute_method_b) { false }

      it { expect(subject).to_not receive(:todo_method_b) }
    end
  end

  describe '.call 2' do
    subject { described_class.new(execute_method_a: execute_method_a, execute_method_b: execute_method_b) }
    let(:execute_method_a) {}
    let(:execute_method_b) {}

    after(:each) { subject.call2 }

    context 'when execute_method_a is true' do
      let(:execute_method_a) { true }

      it { expect(Rails.logger).to receive(:info).with('executed a') }
    end

    context 'when execute_method_b is true' do
      let(:execute_method_b) { true }

      it { expect(Rails.logger).to receive(:info).with('executed b') }
    end

    context 'when execute_method_a is false' do
      let(:execute_method_a) { false }

      it { expect(Rails.logger).to_not receive(:info).with('executed a') }
    end

    context 'when execute_method_b is false' do
      let(:execute_method_b) { false }

      it { expect(Rails.logger).to_not receive(:info).with('executed b') }
    end
  end
end
