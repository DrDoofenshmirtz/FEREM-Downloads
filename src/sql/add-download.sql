create function add_download(_user_id text, _e_mail text, _download_id text)
  -- The Racket driver somehow doesn't know how to handle 'void' results, hence 
  -- we declare the return type as boolean and always return 'true'.
  returns boolean as 
$$
begin

  -- Lock the 'users' table to ensure an atomic 'insert if absent' without 
  -- risking a constraint violation caused by a concurrent insert for the 
  -- same e-mail address.
  lock table only users;
  
  -- Insert a user row with the given user id and e-mail address unless a user
  -- with the same e-mail address already exists.
  insert into users (id, e_mail)
    select cast(_user_id as uuid), _e_mail where not exists 
      (select users.id from users where users.e_mail = _e_mail);
 
  -- Insert a download row for the user with the given e-mail, regardless if
  -- the user already existed or has just been newly created. 
  insert into downloads (id, user_id)
    select cast(_download_id as uuid), users.id from users 
      where users.e_mail = _e_mail;
      
  return true;
end;
$$ language plpgsql;

