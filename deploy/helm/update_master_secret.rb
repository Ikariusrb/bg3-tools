# frozen_string_literal: true

tmp_secret = Tempfile.new.path
tmp_sealed_secret = Tempfile.new.path
secret_namespace = "apps-production"
secret_name = "#{Rails.application.name}-master-key"
secret_key = "RAILS_MASTER_KEY"
secret_data = File.read(Rails.root.join("config/credentials/production.key"))
system("kubectl create secret generic #{secret_name} --dry-run=client --from-literal \"#{secret_key}=#{secret_data}\" -n #{secret_namespace} -o json > #{tmp_secret}")
system("kubeseal -f #{tmp_secret} -w #{tmp_sealed_secret}")
sealed_secret_value = YAML.load_file(tmp_sealed_secret).dig("spec", "encryptedData", "RAILS_MASTER_KEY")
secrets_values_data = { "sealed_secrets" => { "RAILS_MASTER_KEY" => sealed_secret_value } }.to_yaml
File.write(Rails.root.join("deploy/helm/secrets-values.yaml"), secrets_values_data)
File.unlink(tmp_secret) if File.exist?(tmp_secret)
File.unlink(tmp_sealed_secret) if File.exist?(tmp_sealed_secret)
