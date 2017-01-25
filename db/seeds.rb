require 'open-uri'
require 'json'

result = open("https://clinicaltrialsapi.cancer.gov/v1/clinical-trials?include=diseases.synonyms")
result = JSON.parse(result.read)


all_diseases = result['trials'].map do |set|
  set["diseases"]
end.flatten

all_diseases_strings = []
all_diseases.each do |hash|
  all_diseases_strings += hash["synonyms"]
end

all_diseases_strings.uniq.each do |disease|
  Disease.create(name: disease)
end
