const repository =  require('../repositories/items');

exports.getAllItems = async (req, res) => {
  let items = await repository.getAllItems();
  return res.json(items);
};

exports.getItemByUUID = async (req, res) => {
  let item = await repository.getItemByUUID(req.params.uuid)
  return res.json(item);
}

exports.getItemByBarcode = async (req, res) => {
  let item = await repository.getItemByBarcode(req.params.barcode.substring(0, 11))
  return res.json(item);
}
