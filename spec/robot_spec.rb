require_relative '../model/robot'
require_relative '../model/orientation'

RSpec.describe Robot do
  
  subject {described_class.new}
  
  before do
    allow(ENV).to receive(:[]).with('TABLEBOARD_X').and_return("5")
    allow(ENV).to receive(:[]).with('TABLEBOARD_Y').and_return("5")
  end

  it 'has a nil initial position' do
    expect(subject.position).to eq(nil)
  end

  it 'has a nil facing position' do
    expect(subject.facing).to eq(nil)
  end
  
  it 'has not being placed into the tableboard' do
    expect(subject.setted).to eq(false)
  end

  describe '.can_move?' do
    it 'has not being placed into the tableboard' do
      expect(subject.can_move?('north')).to eq(false)
    end

    it 'is positioned into the tableboard' do
      subject.place(0,2,'NORTH')

      expect(subject.setted).to eq(true)
      expect(subject.can_move?('north')).to eq(true)
      expect(subject.can_move?('south')).to eq(false)
    end
  end

  describe '.place' do
    it 'is positioned into the tableboard' do
      subject.place(2,2,'NORTH')

      expect(subject.setted).to eq(true)
      expect(subject.position).to eq([2,2])
      expect(subject.facing).to eq(Orientation::North.instance)
    end

    it 'skip the command when position is out of the tableboard' do
      subject.place(6,2,'NORTH')

      expect(subject.setted).to eq(false)
      expect(subject.position).not_to eq([6,2])
      expect(subject.facing).to eq(nil)
    end
  end

  describe '.left' do
    it 'do nothing when is not setted' do
      subject.left

      expect(subject.setted).to eq(false)
      expect(subject.position).to eq(nil)
      expect(subject.facing).to eq(nil)
    end

    it 'when robot is setted' do  
      subject.place(3,3,'WEST')
      subject.left
      
      expect(subject.facing).to eq(Orientation::South.instance)
      expect(subject.facing).not_to eq(Orientation::North.instance)
    end
  end

  describe '.right' do
    it 'do nothing when is not setted' do
      subject.right

      expect(subject.setted).to eq(false)
      expect(subject.position).to eq(nil)
      expect(subject.facing).to eq(nil)
    end

      
    it 'when robot is setted' do  
      subject.place(3,3,'SOUTH')
      subject.right

      expect(subject.facing).to eq(Orientation::West.instance)
      expect(subject.facing).not_to eq(Orientation::East.instance)
    end
  end

  describe '.move' do
    it 'do nothing when is not setted' do
      subject.move

      expect(subject.setted).to eq(false)
      expect(subject.position).to eq(nil)
      expect(subject.facing).to eq(nil)
    end

    context 'when robot is setted' do

      it 'moves if not going to fall over' do  
        subject.place(2,2,'NORTH')
        subject.move
        expect(subject.position).to eq([3,2])
      end

      it 'do not move because is going to fall over' do  
        subject.place(0,2,'SOUTH')
        subject.move
        expect(subject.position).to eq([0,2])
      end
    end
  end

  describe '.report' do
    context 'when is not setted' do
      it 'sholud be an empty string' do
        expect(subject.report).to eq('')
      end
    end

    context 'when is setted' do
      it 'sholud be a right report' do
        subject.place(1,2,'SOUTH')
        expect(subject.report).to eq('Output: 1,2,SOUTH')
      end

      it 'sholud be a report' do
        subject.place(1,2,'SOUTH')
        subject.left
        expect(subject.report).to eq('Output: 1,2,EAST')
      end

    end
  end

  describe 'general test' do
    context 'All movements inside the tableboard' do
      it 'sholud move without skip any command' do
        subject.place(1,1,'NORTH')
        subject.right
        subject.move
        subject.left
        subject.move
        expect(subject.report).to eq('Output: 2,2,NORTH')
      end
    end

    context 'All movements inside the tableboard' do
      it 'sholud move skipping some commands' do
        subject.place(0,0,'SOUTH')
        subject.move
        subject.move
        subject.move
        subject.left
        subject.move
        subject.move
        subject.move
        expect(subject.report).to eq('Output: 0,3,EAST')
      end
    end
  end

end