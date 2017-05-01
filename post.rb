require 'sqlite3'

class Post

  @@SQLITE_DB_FILE = 'notepad.sqlite'

  def self.post_types
    {:Memo => Memo, :Task => Task, :Link => Link}
  end

  def self.create(type)
    post_types[type].new
  end

  def self.find(limit, type, id)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)

    # 1.First version - specific entry
    if !id.nil?
      db.results_as_hash = true

      result = db.execute("SELECT * FROM posts WHERE rowid = ?", id)
      result = result[0] if result.is_a? Array
      db.close
      if result.empty?
        puts "This id - #{id} not found in base..."
        return nil
      else
        post = create(result['type'].to_sym)
        post.load_data(result)
        return post
      end
    else
    #2. Second version - all entry
      db.results_as_hash = false

      #Zaput v SQLite
      query = "SELECT rowid, * FROM posts "
      query += "WHERE type = :type " unless type.nil?
      query += "ORDER by rowid DESC "                     # - sortyvanya po ID po spadanyu; "ORDER by rowid ASC " - sortyvanya po ID po zrostanyu;
      query += "LIMIT :limit " unless limit.nil?

      statement = db.prepare(query)

      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute!

      statement.close
      db.close

      return result
    end
  end

  def initialize
    @created_at = Time.now
    @text = nil
  end

  def read_from_consol
    #todo
  end

  def to_strings
    #todo
  end

  def save
    file = File.new(file_path, "w:UTF-8")
    for item in to_strings do
      file.puts(item)
    end
    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    current_path + "/" + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true

    db.execute(
        "INSERT INTO posts (#{to_db_hash.keys.join(',')})" +
            " VALUES (#{('?,'*to_db_hash.keys.size).chomp(',')})", to_db_hash.values
    )

    insert_row_id = db.last_insert_row_id

    db.close

    insert_row_id
  end

  def to_db_hash
    { :type => self.class.name, :created_at => @created_at.to_s }
  end

  # Otrumye na vhodi - hash danuh i povunen zapovnutu svoi polya
  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end

end