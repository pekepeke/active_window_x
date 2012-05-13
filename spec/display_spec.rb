# -*- coding:utf-8; mode:ruby; -*-

require 'active_window_x'

include ActiveWindowX

describe Xlib do
  before do
    @display = Display.new nil
  end
  after do
    @display.close
  end

  describe '#root_window' do
    before do
      @root_id = 123456
      Xlib.should_receive(:default_root_window).and_return(@root_id)
    end
    it 'should return the root window' do
      r = @display.root_window
      r.id.should == @root_id
      r.should be_a RootWindow
    end
  end

  describe '#next_event' do
    before do
      @root = @display.root_window
      @root.select_input Xlib::PropertyChangeMask
      @event = mock Xlib::XPropertyEvent
      @event.stub(:type){@type}
      @window_id = 222
      @event.stub(:window){@window_id}
      @atom_id = 333
      @event.stub(:atom){@atom_id}
      Xlib.should_receive(:x_next_event).and_return(@event)
    end
    context 'with PropertyChangeMask' do
      before do
        @type = Xlib::PropertyNotify
      end
      it 'should return a PropertyEvent' do
        ev = @display.next_event
        ev.type.should == @event.type
        ev.window.id.should == @event.window
        ev.atom.id.should == @event.atom
      end
    end
    context 'with other event type' do
      before do
        @type = 0
      end
      it 'should return a PropertyEvent' do
        ev = @display.next_event
        ev.type.should == @event.type
      end
    end
  end

end
