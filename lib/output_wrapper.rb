require 'delegate'

class OutputWrapper
  def initialize(output)
    @output = output
  end

  def <<(*args)
    @output.write(*args)
  end 
end
