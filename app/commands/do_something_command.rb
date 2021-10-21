class DoSomethingCommand
  extend ApplicationCommand

  def initialize(execute_method_a:, execute_method_b:)
    @execute_method_a = execute_method_a
    @execute_method_b = execute_method_b
  end

  def call
    todo_method_a if execute_method_a
    todo_method_b if execute_method_b

    true
  end

  def call2
    todo_method_a_2
    todo_method_b_2

    true
  end

  private

  attr_reader :execute_method_a, :execute_method_b

  def todo_method_a
    Rails.logger.info 'executed a'
  end

  def todo_method_b
    Rails.logger.info 'executed b'
  end

  def todo_method_a_2
    return unless execute_method_a

    Rails.logger.info 'executed a'
  end

  def todo_method_b_2
    return unless execute_method_b

    Rails.logger.info 'executed b'
  end
end