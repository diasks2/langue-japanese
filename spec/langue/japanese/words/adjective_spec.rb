# -*- coding: utf-8 -*-
require 'spec_helper'
require 'langue/japanese/words/adjective'

describe Langue::Japanese::Adjective do
  it 'inherits Langue::Adjective' do
    described_class.superclass.should == Langue::Adjective
  end
end

describe Langue::Japanese::Adjective, '.take' do
  after do
    @pairs.each do |text, size|
      morphemes = parser.parse(text)
      described_class.take(morphemes, 0).should == size
    end
  end

  it 'takes an adjective' do
    @pairs = {
      '可愛いこと'     => 1,
      'かっこいいこと' => 1,
      '会話だ'         => 0,
      '話すこと'       => 0
    }
  end

  it 'takes an adjective with prefix' do
    @pairs = {
      'くそ可愛いこと'       => 2,
      'くそくそかっこいいこと' => 3,
      'くそ会話だ'             => 0
    }
  end

  it 'takes an adjective with suffix' do
    @pairs = {
      '可愛いっぽいこと' => 2
    }
  end

  it 'takes a successive adjective' do
    @pairs = {
      '可愛がたいこと' => 2
    }
  end

  it 'takes a negative adjective' do
    @pairs = {
      '可愛くないこと'     => 2,
      'かっこよくないこと' => 2
    }
  end

  it 'takes a perfective adjective' do
    @pairs = {
      '可愛かったこと'     => 2,
      'かっこよかったこと' => 2
    }
  end

  it 'takes a complex adjective' do
    @pairs = {
      'くそ可愛がたくなかったこと' => 5,
      'クソかっこよくないこと'     => 3,
      '美しくなかったこと'         => 3,
      '厳しいっぽくなかったこと'   => 4
    }
  end

  it 'takes an adjective by other' do
    @pairs = {
      '可愛いでしょう' => 3
    }
  end
end

describe Langue::Japanese::Adjective, '#key_morpheme' do
  it 'returns the categorematic adjective or the noncategorematic adjective' do
    {
      '可愛い'     => 0,
      '可愛っぽい' => 0,
      '可愛くない' => 0,
      '可愛がたい' => 1
    }.each do |text, index|
      word = adjective(text)
      word.key_morpheme.should == word[index]
    end
  end

  context 'with an empty word' do
    it 'returns nil' do
      word = described_class.new
      word.key_morpheme.should be_nil
    end
  end

  context 'with word that is not adjective' do
    it 'raises Langue::Japanese::InvalidWord' do
      %w(会話 話す).each do |text|
        word = adjective(text)
        lambda { word.key_morpheme }.should raise_error(Langue::Japanese::InvalidWord, %("#{text}" is invalid a word as an adjective))
      end
    end
  end
end

describe Langue::Japanese::Adjective, '#prefix' do
  it 'returns the prefix' do
    adjective('くそくそ可愛っぽくない').prefix.should == 'くそくそ'
  end
end

describe Langue::Japanese::Adjective, '#body' do
  it 'returns the text with the prefix' do
    adjective('くそくそ可愛っぽくない').body.should == '可愛い'
  end
end

describe Langue::Japanese::Adjective, '#negative?' do
  it 'returns true if it is negative' do
    adjective('可愛くない').should be_negative
  end

  it 'returns false if it is not negative' do
    adjective('可愛い').should_not be_negative
  end
end

describe Langue::Japanese::Adjective, '#perfective?' do
  it 'returns true if it is perfective' do
    adjective('可愛かった').should be_perfective
  end

  it 'returns false if it is not perfective' do
    adjective('可愛い').should_not be_perfective
  end
end
