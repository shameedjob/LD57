class_name  DictionaryHelper

static func difference(new_dict:Dictionary, original:Dictionary)->Dictionary:
	var output = {}
	for d in new_dict:
		if not original.has(d):
			output[d] = {"new":new_dict[d], "old":null}
			continue
		if  original[d] != new_dict[d]:
			output[d] = {"new": new_dict[d], "old": original[d]}
	return output
