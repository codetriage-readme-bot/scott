module EpisodeOperations
  class AnalyseAll < FunctionalOperations::Operation
    LIMIT_PER_RUN = ENV["EPISODE_ANALYSIS_LIMIT_PER_RUN"]

    def perform
      Episode.not_analysed.limit(LIMIT_PER_RUN).order_by(published_at: :desc).each do |episode|
        analyse!(episode.audio)
      end
    end

    def analyse!(audio)
      run(AudioOperations::Analyse, audio: audio)
    end
  end
end
