require File.join(File.dirname(__FILE__), %w[ .. spec_helper])

describe Roart::Attachment do

  context "instance" do
    subject { described_class.new("zero", File.open("/dev/zero", "rb")) }

    it { should respond_to(:path) }
    it { should respond_to(:read) }
    it { should respond_to(:name) }
  end

  describe ".detect" do

    it "should create collection from attachments array" do
      described_class.detect(['/dev/null', '/dev/zero']).should be_a(Enumerable)
      described_class.detect(['/dev/null', '/dev/zero']).first.should be_a(Roart::Attachment)
    end

    it "should create collection from attachments as params" do
      described_class.detect('/dev/null', '/dev/zero').should be_a(Enumerable)
      described_class.detect(['/dev/null', '/dev/zero']).first.should be_a(Roart::Attachment)
    end

    it "should create collection from one attachment" do
      described_class.detect('/dev/null').should be_a(Enumerable)
      described_class.detect(['/dev/null', '/dev/zero']).first.should be_a(Roart::Attachment)
    end

    it "should create using String filename" do
      @attachment = described_class.detect('/dev/null').first
      @attachment.file.should be_a(File)
    end

    it "should create using File descriptor" do
      @attachment = described_class.detect(File.open('/dev/null', 'rb')).first
      @attachment.file.should be_a(File)
    end

    it "should create using Tempfile instance" do
      @tempfile = mock(:tempfile, :original_filename => "test name", :open => "file descriptor")
      @attachment = described_class.detect(@tempfile).first
      @attachment.file.should == "file descriptor"
    end

  end

  describe Roart::AttachmentCollection, ".to_payload" do
    subject { Roart::Attachment.detect(['/dev/null', '/dev/zero']) }

    it "should return a Hash" do
      subject.to_payload.should be_a(Hash)
    end

    it "should generate keys for attachments" do
      subject.to_payload.should have_key("attachment_1")
      subject.to_payload.should have_key("attachment_2")
    end

    it "should contain file descriptors" do
      subject.to_payload["attachment_1"].should be_a(File)
    end
  end

end