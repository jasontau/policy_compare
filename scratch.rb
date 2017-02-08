response = HTTP.post("https://pdftables.com/api?key=09m0pwowr88n&format=csv",
                  form: {
                    :f   => HTTP::FormData::File.new("app/assets/policies/raw/PeasantMoonQuote.pdf")
                    })


url = URI.parse("http://localhost:3000/download_zip")
resp, data = Net::HTTP.post_form(url, form: { :f => HTTP::FormData::File.new("app/assets/policies/raw/PeasantMoonQuote.pdf")})
puts resp.inspect
puts data.inspect

"http://localhost:3000/download_zip"


response = open("https://pdftables.com/api?key=09m0pwowr88n")

Zip::File.open(response) do |zipfile|
  zipfile.each do |entry|
    extension = File.extname(entry.name)
    basename = File.basename(entry.name, extension)

    tempfile = Tempfile.new([basename, extension])
    tempfile.binmode
    tempfile.write entry.get_input_stream.read
    tempfile.rewind
  end
end

#============= HTTMultiParty

c = HTTMultiParty.post('https://pdftables.com/api?key=09m0pwowr88n&format=csv', :query => { f: File.new("app/assets/policies/raw/PeasantMoonQuote.pdf", "r") })


#============== HTTP multipart-post

require 'net/http/post/multipart'

address = 'https://pdftables.com/api?key=09m0pwowr88n&format=csv'
file = 'app/assets/policies/raw/PeasantMoonQuote.pdf'
url = URI.parse(address)
newfile = File.new(file)
upload = UploadIO.new(newfile, "application/pdf", "PeasantMoonQuote.pdf")

#================ raw multipart request

require "net/http"
require "uri"

BOUNDARY = "AaB03x"

uri = URI.parse("https://pdftables.com/api?key=09m0pwowr88n&format=csv")
file = "app/assets/policies/raw/PeasantMoonQuote.pdf"

post_body = []
post_body < < "--#{BOUNDARY}rn"
post_body < < "Content-Disposition: form-data; name="datafile"; filename="#{File.basename(file)}"rn"
post_body < < "Content-Type: text/plainrn"
post_body < < "rn"
post_body < < File.read(file)
post_body < < "rn--#{BOUNDARY}--rn"

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri.request_uri)
request.body = post_body.join
request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

resp = http.request(request)
