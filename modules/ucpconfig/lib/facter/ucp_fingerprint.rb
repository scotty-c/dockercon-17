
  Facter.add('ucp_fingerprint') do
    setcode do
      Facter::Core::Execution.exec("echo -n | openssl s_client -connect 172.17.10.101:443 2> /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | openssl x509 -noout -fingerprint -sha1 | cut -d= -f2")
    end
 end