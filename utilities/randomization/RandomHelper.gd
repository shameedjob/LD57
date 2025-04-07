class_name RandomHelper
static var random_engine = {}

static func reset_random_engine():
	random_engine = {}
	random_engine["seed"] = get_random_seed()
	random_engine["inc"] = 0
	random_engine["generator"] = new_generator(random_engine["seed"])
	random_engine["paths"] = {}

static func random_choice(path:String, collection:Array):
	var f = get_next_float(path)
	return collection[collection.size()*f]
	
static func get_next_float(path:String = "r")->float:
	var re = random_engine
	if not  random_engine["paths"].has(path):
		random_engine["paths"][path] =hash(path)
	
	random_engine["generator"].seed = hash(random_engine["seed"]+str(random_engine["paths"][path]))
	random_engine["paths"][path] += 1
	var f = random_engine["generator"].randf()
	return f   

static func peak_float(path:String="r", to:int=1)->float:
	if not random_engine["paths"].has(path):
		random_engine["paths"][path] =hash(path)
	
	random_engine["paths"][path] += to
	random_engine["generator"].seed = hash(random_engine["seed"]+str(random_engine["paths"][path]))
	random_engine["paths"][path] -= to
	
	return random_engine["generator"].randf()
	
static func get_next_int(path:String="r")->int:
	if not random_engine["paths"].has(path):
		random_engine["paths"][path] = hash(path)
	
	random_engine["generator"].seed = hash(random_engine["seed"]+str(random_engine["paths"][path]))
	random_engine["paths"][path] += 1
	
	return random_engine["generator"].randi()

static func peak_int(path="r", to=1)->int:
	if not random_engine["paths"].has(path):
		random_engine["paths"][path] =hash(path)
	
	random_engine["paths"][path] += to
	random_engine["generator"].seed = hash(random_engine["seed"]+str(random_engine["paths"][path]))
	random_engine["paths"][path] -= to
	
	return random_engine["generator"].randi()
static func new_generator(seed):
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(seed)
	return rng
	
static func get_random_seed():
	var time = Time.get_unix_time_from_system()
	var seed = [];
	for i in [1,2,3,4,5,6,7,8]:
		time += time*log(i)*(i-4)+1
		print(time)
		seed.append(abs(int(time))%36)
	seed.shuffle()
	var key = [0,1,2,3,4,5,6,7,8,9]
	for i in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
		key.append(i)
	var seed_str = ""
	for i in seed:
		seed_str += str(key[i])
	return seed_str
