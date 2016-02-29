require 'erb'
require 'bosh/template/evaluation_context'

class Hash
  def dig(dotted_path)
    key, rest = dotted_path.split '.', 2
    match = self[key]
    if !rest or match.nil?
      return match
    else
      return match.dig(rest)
    end
  end

  def dig_add(dotted_path, value)
    key, rest = dotted_path.split '.', 2
    match = self[key]
    if not rest
      return self[key] = value
    elsif match.nil?
      self[key] = {}
    end
    self[key].dig_add(rest, value)
  end

  def populate_default_properties_from_spec(spec)
    spec["properties"].each do |key, val|
      prop_key = "properties.#{key}"
      default = val["default"]
      if not default.nil?
        if not self.dig(prop_key)
          self.dig_add(prop_key, default)
        end
      end
    end
  end
end

def render_template(template, spec, manifest)
  job_spec = {}
  job_spec["properties"] = manifest["properties"].clone()
  job_spec.populate_default_properties_from_spec(spec)

  context = Bosh::Template::EvaluationContext.new(job_spec)
  erb = ERB.new(template)
  return erb.result(context.get_binding)
end
