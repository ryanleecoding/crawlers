def get_post_comment
  table = CSV.parse(File.read("post_id.csv"), headers: false)

  post_comments = []
  table.each do |line|
    begin
      count = 0
      last_floor = 0
      totcnt = 0
      puts "=============#{line[2]}/#{line[0]}=============" #顯示"版名/文章ID" 回文過多方便確認
      while true
        sleep(0.1)
        url = "https://www.dcard.tw/_api/posts/#{line[0]}/comments?after=#{last_floor}"
        uri = URI(url)
        data = Net::HTTP.get(uri)
        items = JSON.parse(data)

        if items.size < 30
          sleep(0.1)
          items.each do |item|
            post_comments << [item["id"], item["postId"], item["createdAt"], item["updatedAt"], item["floor"], item["content"], item["likeCount"], item["gender"]]
            count += 1
            totcnt += 1
            puts "#{totcnt}----#{item["content"]}"
          end
          break
        else
          sleep(0.1)
          items.each do |item|
            post_comments << [item["id"], item["postId"], item["createdAt"], item["updatedAt"], item["floor"], item["content"], item["likeCount"], item["gender"]]
            count += 1
            totcnt += 1

            puts "#{totcnt}----#{item["content"]}"
            if count == 30
              last_floor = item["floor"]
              count = 0
            end
          end
        end
      end
    rescue => e
      puts "==========================================="
      puts "error type=#{e.class}, message=#{e.message}"
      puts "==========================================="
    end
  end

  File.write("post_comment_new.csv", post_comments.map(&:to_csv).join)
end
