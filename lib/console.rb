class Console
  include Output

  def main_menu
    Output.greeting

    a = gets.chomp

    if a == 'create'
      create
    elsif a == 'load'
      load
    else
      exit
    end
  end

  alias :main_menu :console
end
