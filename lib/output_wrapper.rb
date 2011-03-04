require 'delegate'

class OutputWrapper
  def initialize(output)
    @output = output
  end

  def <<(*args)
    @output.write(*args)
  end

  def puts(*args)
    @output.write(*args)
    @output.write("\n")
  end

  def write(*args)
    @output.write(*args)
  end


end
