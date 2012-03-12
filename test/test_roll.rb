require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestRoll < Test::Unit::TestCase

  def setup
    @test = Dieroll::Roll.new('1d6+2')
    @two_dice = Dieroll::Roll.new('1d6+1d4-2')
    #@_4d6_drop_low = Dieroll::Roll.new('4d6/l')
  end

  def teardown
  end

  def test_class_roll
    roll = Dieroll::Roll.string('3d6+10')
    assert !roll.empty?
    assert_equal 2, roll.count
    assert_equal roll.first, roll[1].total+10

    roll = Dieroll::Roll.string('1d6+1d4+10')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total+roll[2].total+10

    roll = Dieroll::Roll.string('2+2d6+2+2d2+1')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total+roll[2].total+5

    roll = Dieroll::Roll.string('3d6-2d6+10-5')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total-roll[2].total+5

    roll = Dieroll::Roll.string('4d6\l')
    assert !roll.empty?
    assert_equal 2, roll.count
    assert_equal roll.first, roll[1].total
    dice = roll[1].dice
    dice.sort!.shift
    assert_equal dice.inject(0){|sum, x| sum+x}, roll[1].total
  end
  
  def test_roll_init
    assert_equal '1d6+2', @test.string
    assert @test.results.empty?
    assert_equal [[1,6],[2]], @test.sets
    assert_equal ['+','+'], @test.plusminus

    assert_equal '1d6+1d4-2', @two_dice.string
    assert @two_dice.results.empty?
    assert_equal [[1,6],[1,4],[2]], @two_dice.sets
    assert_equal ['+','+','-'], @two_dice.plusminus
  end

  def test_obj_roll
    result = @test.roll
    assert !@test.results.empty?
    assert_equal result, @test.results.last.first
    4.times do
      @test.roll
    end
    assert_equal 5, @test.results.count
  end
  
  def test_to_s
    assert_match "Rolled 1d6+2 0 times:\n", @test.to_s
    @test.roll
    @test.roll
    assert_match /Rolled 1d6\+2 2 times:\nResult 1:\nTotal: \d+\n(\d+):1d6:\1\n\nResult 2:\nTotal: \d+\n(\d+):1d6:\2\n\n/, @test.to_s
  end
end
