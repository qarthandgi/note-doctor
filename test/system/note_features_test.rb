require "application_system_test_case"

class NoteFeaturesTest < ApplicationSystemTestCase
  setup do
    @note_feature = note_features(:one)
  end

  test "visiting the index" do
    visit note_features_url
    assert_selector "h1", text: "Note Features"
  end

  test "creating a Note feature" do
    visit note_features_url
    click_on "New Note Feature"

    fill_in "Progress note", with: @note_feature.progress_note_id
    fill_in "Text idx", with: @note_feature.text_idx
    fill_in "Type", with: @note_feature.type
    fill_in "Value", with: @note_feature.value
    click_on "Create Note feature"

    assert_text "Note feature was successfully created"
    click_on "Back"
  end

  test "updating a Note feature" do
    visit note_features_url
    click_on "Edit", match: :first

    fill_in "Progress note", with: @note_feature.progress_note_id
    fill_in "Text idx", with: @note_feature.text_idx
    fill_in "Type", with: @note_feature.type
    fill_in "Value", with: @note_feature.value
    click_on "Update Note feature"

    assert_text "Note feature was successfully updated"
    click_on "Back"
  end

  test "destroying a Note feature" do
    visit note_features_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Note feature was successfully destroyed"
  end
end
