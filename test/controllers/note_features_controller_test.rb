require 'test_helper'

class NoteFeaturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note_feature = note_features(:one)
  end

  test "should get index" do
    get note_features_url
    assert_response :success
  end

  test "should get new" do
    get new_note_feature_url
    assert_response :success
  end

  test "should create note_feature" do
    assert_difference('NoteFeature.count') do
      post note_features_url, params: { note_feature: { progress_note_id: @note_feature.progress_note_id, text_idx: @note_feature.text_idx, type: @note_feature.type, value: @note_feature.value } }
    end

    assert_redirected_to note_feature_url(NoteFeature.last)
  end

  test "should show note_feature" do
    get note_feature_url(@note_feature)
    assert_response :success
  end

  test "should get edit" do
    get edit_note_feature_url(@note_feature)
    assert_response :success
  end

  test "should update note_feature" do
    patch note_feature_url(@note_feature), params: { note_feature: { progress_note_id: @note_feature.progress_note_id, text_idx: @note_feature.text_idx, type: @note_feature.type, value: @note_feature.value } }
    assert_redirected_to note_feature_url(@note_feature)
  end

  test "should destroy note_feature" do
    assert_difference('NoteFeature.count', -1) do
      delete note_feature_url(@note_feature)
    end

    assert_redirected_to note_features_url
  end
end
