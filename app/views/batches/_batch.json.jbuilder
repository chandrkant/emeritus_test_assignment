# frozen_string_literal: true

json.extract! batch, :id, :name, :start_date, :end_date, :school_id, :course_id
json.school_name batch.school.name
json.course_name batch.course.name
