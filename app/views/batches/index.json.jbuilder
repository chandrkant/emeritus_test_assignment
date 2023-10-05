# frozen_string_literal: true

json.array! @batches, partial: 'batches/batch', as: :batch
