module Api
  module V1
    class NoteFeaturesController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_note_feature, only: [:show, :edit, :update, :destroy]

      # GET /note_features
      # GET /note_features.json
      def index
        @note_features = NoteFeature.all
      end

      def stats
        render json: {trials: trials, goals: goals, errors: errors}
      end

      # POST /note_features
      # POST /note_features.json
      def create
        @note_features = request.parameters['_json'].map do |n|
          note = NoteFeature.new(n)
          note.save
        end
        # @note_features.each(&:save)
        render json: @note_features
      end

      private
        def trials
          @trial_series = NoteFeature.where(feature_type: 'trialSeries')
          @correct_trials = @trial_series.map do |n|
            arr = n.value.split('/')
            arr[0].to_i
          end
          @total_trials = @trial_series.map do |n|
            arr = n.value.split('/')
            arr[1].to_i
          end
          return {correct_trials: @correct_trials.sum, total_trials: @total_trials.sum}
        end
        def goals
          @stg = NoteFeature.where(feature_type: 'stg')
          @ltg = NoteFeature.where(feature_type: 'ltg')

          return { short_term: @stg.map {|n| n.value}, long_term: @ltg.map {|n| n.value} }
        end
        def errors
          db_errors = NoteFeature.where(feature_type: 'error')
          all_errors = db_errors.map { |e| e.value }
          unique_errors = all_errors.uniq

          errors = unique_errors.map do |e|
            count = all_errors.count { |y| y == e }
            {error: e, count: count}
          end
          return errors
        end
        # Use callbacks to share common setup or constraints between actions.
        def set_note_feature
          @note_feature = NoteFeature.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def note_feature_params
          params.require(:note_feature).permit(:feature_type, :value, :text_idx, :progress_note_id)
        end
        def note_features_params
          params.permit(:_json, :feature_type, :value, :text_idx, :progress_note_id)
        end
    end
  end
end