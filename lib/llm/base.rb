module Llm
  class Base
    def call(prompt)
      raise NotImplementedError
    end
  end
end
