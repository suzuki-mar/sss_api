class DocumentsSerializer < ActiveModel::Serializer
  attributes :log_date, :problem_solvings, :reframings

  def problem_solvings
    return [] if object.problem_solvings.nil?
    object.problem_solvings.map do |ps|
      ProblemSolvingSerializer.new(ps).attributes
    end

  end

  def reframings
    return [] if object.reframings.nil?
    object.reframings.map do |r|
      ReframingSerializer.new(r).attributes
    end
  end

end
