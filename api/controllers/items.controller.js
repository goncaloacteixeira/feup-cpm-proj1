const repository =  require('../repositories/repository');

exports.getAllItems = async (req, res) => {
  let items = await repository.getAllItems();
  return res.send({items});
};

exports.getItemById = async (req, res) => {
  let item = await repository.getItemById(req.params.id)
  return res.send({item});
}
