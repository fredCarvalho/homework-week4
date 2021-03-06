class Frame
  attr_accessor :rolls,:actual_frame
  def initialize
    @rolls=Array.new(2,0)
    @actual_frame=0
  end

  def strike?
    @rolls[1]=='X'?true:false
  end

  def spare?
    rolls[1]=='/'?true:false
  end

  def regular?
    @rolls[0]+@rolls[1]<10?true:false
  end

  def frame_score
    if @rolls[1]=='/'
      return 10
    elsif @rolls[1]=='X'
      return 10
    else 
      @rolls[0]+@rolls[1]
    end
  end

  def roll(pins)
    if pins==10 and @actual_frame==0 then
      it_was_strike
    elsif @actual_frame==1 and @rolls[0]+pins==10
      it_was_spare
    else
      it_was_regular_move(pins)
    end
  end

  def it_was_strike
    @rolls[0]=10
    @rolls[1]='X'
    @actual_frame=-1
  end

  def it_was_spare
    @rolls[1]='/'
    @actual_frame=-1
  end

  def it_was_regular_move(pins)
    if @actual_frame==0
      @rolls[@actual_frame]=pins
      @actual_frame=1
    else
      @rolls[@actual_frame]=pins
      @actual_frame=-1
    end
  end

  def can_do_roll?
    actual_frame!=-1?true:false
  end
end

class Bowling
  def initialize
    @frames=Array.new(18){|i| Frame.new}
    @actual_frame=0
  end

  def valid_pins?(pins)
    if (pins<=10 and pins>=0) then true else false
  end
end

  def roll(pins) 
    if not valid_pins?(pins) then
      	raise 'The pins must be between 0 and 10.'
    else
      if @frames[@actual_frame].can_do_roll? then
        @frames[@actual_frame].roll(pins)
      else
        @actual_frame+=1
        @frames[@actual_frame].roll(pins)
      end
    end 
  end

  def score
    points=0
    frame_counter=0
    while frame_counter<=@actual_frame and frame_counter<10 do
      points+=framePoints(frame_counter)
      frame_counter+=1
    end
      return points
  end


  def framePoints(frame)
    score=0
    if @frames[frame].spare?
      return spare_points(frame)
    elsif @frames[frame].strike?
      return strike_points(frame)
    else
      return regular_points(frame)
    end
  end

  def spare_points(frame)
    return 10+@frames[frame+1].rolls[0]
  end

  def strike_points(frame)
    points=10 
    if @frames[frame+1].strike? then
      points+=10+@frames[frame+2].rolls[0]
    else
      points+=@frames[frame+1].frame_score
    end
    return points
  end

  def regular_points(frame)
    return @frames[frame].frame_score
  end

end
