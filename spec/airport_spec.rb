require 'airport'
require 'plane'

describe Airport do
  it { is_expected.to respond_to(:land_plane).with(1).argument  }
  it { is_expected.to respond_to(:takeoff_plane).with(1).argument  }
  it { is_expected.to respond_to(:weather) }

  describe '#stormy?' do
    it 'can check if weather is stormy' do
      expect(subject.stormy?).to satisfy { |stormy| stormy == true || stormy == false}
    end
  end

  describe '#land_plane' do
    it 'should allow plane to land at airport' do
      plane = Plane.new
      expect(subject.land_plane(plane)).to eq "#{plane} has completed landing"
    end

    it 'should only allow airborne planes to land' do
      plane = Plane.new
      subject.land_plane(plane)
      expect{subject.land_plane(plane)}.to raise_error{"Plane is already landed"}
    end

    it 'should confirm that plane has landed' do
      plane = Plane.new
      subject.land_plane(plane)
      expect(plane.airborne?).to eq false
    end

    it 'should not allow landing when airport is full' do
      subject.capacity.times { subject.land_plane Plane.new }
      expect {subject.land_plane(plane)}.to raise_error{"Airport is full!"}
    end

    #it 'should not allow plane to land when stormy' do
    #  plane = Plane.new
    #  subject.weather.is_stormy
    #end
  end

  describe '#takeoff_plane' do
    it 'should allow plane to takeoff from airport' do
      plane = Plane.new
      subject.land_plane(plane)
      subject.takeoff_plane(plane)
      expect(plane).to be_airborne
    end

    it 'should only allow landed planes to takeoff' do
      plane1 = Plane.new
      plane2 = Plane.new
      subject.land_plane(plane1)
      expect{subject.takeoff_plane(plane2)}.to raise_error{"Plane is already airborne"}
    end

    it 'should confirm that plane has taken off' do
      plane = Plane.new
      subject.land_plane(plane)
      expect(subject.takeoff_plane(plane)).to eq "#{plane} has taken off"
    end

    it 'should raise error message if airport is empty' do
      plane = Plane.new
      expect{subject.takeoff_plane(plane)}.to raise_error{"Airport is empty!"}
    end

    it 'allows planes to takeoff from only airports they are landed in' do
      airport1 = Airport.new
      airport2 = Airport.new
      plane = Plane.new
      plane2 = Plane.new
      airport1.land_plane(plane)
      airport2.land_plane(plane2)
      expect{airport1.takeoff_plane(plane2)}.to raise_error{"#{plane} is not in hangar"}
    end

  end

  describe '#capacity' do
    it 'allows a new airport to be created with a default capacity' do
      expect(subject.capacity).to eq Airport::DEFAULT_CAPACITY
    end

    it 'allows default capacity to be overriden' do
      subject.capacity = 40
      expect(subject.capacity).to eq 40
    end
  end


end
