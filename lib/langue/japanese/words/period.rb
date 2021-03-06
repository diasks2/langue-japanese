# -*- coding: utf-8 -*-
require 'langue/word'
require 'langue/japanese/words/classifier'

module Langue
  module Japanese
    class Period < ::Langue::Period
      COMMAS = %w(, ， 、)
      DOTS   = COMMAS + %w(. ． 。 ・ ‥ …)
      MARKS  = %w(! ！ ? ？)

      extend Classifier

      def self.take(morphemes, index)
        if dot?(morphemes, index)
          take_dot(morphemes, index)
        elsif mark?(morphemes, index)
          take_mark(morphemes, index)
        else
          0
        end
      end

      def self.dot?(morphemes, index)
        morphemes.at(index) { |m| DOTS.include?(m.text) }
      end

      def self.mark?(morphemes, index)
        morphemes.at(index) { |m| MARKS.include?(m.text) }
      end

      def self.take_dot(morphemes, index)
        size = 0
        size += 1 while dot?(morphemes, index + size)
        size == 1 && COMMAS.include?(morphemes[index].text) ? 0 : size
      end

      def self.take_mark(morphemes, index)
        size = 0
        size += 1 while mark?(morphemes, index + size)
        size
      end

      def exclamation?
        @exclamation = !!(text =~ /[!！]/) unless instance_variable_defined?(:@exclamation)
        @exclamation
      end

      def question?
        @question = !!(text =~ /[?？]/) unless instance_variable_defined?(:@question)
        @question
      end
    end
  end
end
