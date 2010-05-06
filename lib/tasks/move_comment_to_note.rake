task :comment_to_note => :environment do
  trainings = Training.all
  trainings.each do |training|
    unless training.comment.blank?
      note = training.build_note(:content => training.comment)
      note.save
      training.races.each do |race|
        unless race.comment.blank?
          race_note = race.build_note(:content => race.comment)
          race_note.save
        end
      end
    end
  end
  puts "done"
end