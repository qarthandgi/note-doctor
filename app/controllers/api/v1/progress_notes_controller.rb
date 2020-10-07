module Api
  module V1
    class ProgressNotesController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        @progress_notes = ProgressNote.left_outer_joins(:note_features).distinct
        render json: @progress_notes

      end
      
      def create
        @progress_note = ProgressNote.new(progress_note_params)
        @progress_note.save
        render json: @progress_note
      end

      def update
        @note = ProgressNote.find(params[:id])
        @note.note = params[:note]
        @note.save
        render json: @note
      end

      private
        def progress_note_params
          params.require(:progress_note).permit(:note)
        end
      
    end
  end
end