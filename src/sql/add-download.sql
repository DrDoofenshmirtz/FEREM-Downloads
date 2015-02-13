create function add_download(_user_id text, _e_mail text, _download_id text)
  returns text as
$$
declare
  _user_uuid uuid := cast(_user_id as uuid);
  _download_uuid uuid := cast(_download_id as uuid);
begin

  -- Lock the 'users' table to ensure an atomic 'insert if absent' without 
  -- risking a constraint violation caused by a concurrent insert for the 
  -- same e-mail address.
  lock table only users;
  
  -- Insert a user row with the given user id and e-mail address unless a user
  -- with the same e-mail address already exists (which is never true in case 
  -- the given e-mail is null).
  insert into users (id, e_mail)
    select _user_uuid, _e_mail where not exists 
      (select users.id from users where users.e_mail = _e_mail);

  if _e_mail is not null then  
    -- When a non-null e-mail address has been given, retrieve the user id 
    -- actually related to the given e-mail address. 
    _user_uuid := (select users.id from users where users.e_mail = _e_mail);
  end if;    
      
  -- Insert a download row for the user with the given e-mail, regardless if
  -- the user already existed or has just been newly created. 
  insert into downloads (id, user_id) values(_download_uuid, _user_uuid);
      
  return cast(_user_uuid as text);
end;
$$ language plpgsql;

