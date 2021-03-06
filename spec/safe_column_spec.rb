require 'spec_helper'

class SafeColumnSpec < Minitest::Spec
  describe "A Model with SafeColumn included" do
    let(:model) { MyAmazingModel.create!(:title => "<h3>This is a title</h3>",
        :body => "<p>This is a body</p>") }

    describe "without safe_columns" do
      before do
        MyAmazingModel.allow_safe_columns []
      end

      after do
        MyAmazingModel.allow_safe_columns [:title, :body]
      end

      it "returns the underlying string" do
        model.title.class.must_equal String
        model.body.class.must_equal String
        model.created_at.class.must_equal Time
        model.updated_at.class.must_equal Time
        model.published.must_equal false
      end
    end

    describe "when safe columns are specified" do
      it "wraps it in an ActiveSupport::SafeBuffer" do
        model.title.class.must_equal ActiveSupport::SafeBuffer
        model.body.class.must_equal ActiveSupport::SafeBuffer
        model.created_at.class.must_equal Time
        model.updated_at.class.must_equal Time
        model.published.must_equal false
      end
    end
  end

  describe "A subclass of a model using safe column" do
    let (:model) { MyAmazingSubClassModel.create!(:title => "<h3>This is a title</h3>",
        :body => "<p>This is a body</p>") }

    it "inherits it's safe columns" do
      model.title.class.must_equal ActiveSupport::SafeBuffer
      model.body.class.must_equal ActiveSupport::SafeBuffer
      model.created_at.class.must_equal Time
      model.updated_at.class.must_equal Time
      model.published.must_equal false
    end
  end

  describe "A third-level subclass of a model using safe column" do
    let (:model) { ThirdLevelSubClass.create!(:title => "<h3>This is a title</h3>",
        :body => "<p>This is a body</p>") }

    it "still inherits it's safe columns" do
      model.title.class.must_equal ActiveSupport::SafeBuffer
      model.body.class.must_equal ActiveSupport::SafeBuffer
      model.created_at.class.must_equal Time
      model.updated_at.class.must_equal Time
      model.published.must_equal false
    end
  end

  describe "Any other model" do
    let(:model) { NormalModel.create!(:field => "Field") }

    it "works fine without it" do
      model.field.must_equal "Field"
    end
  end
end