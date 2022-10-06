import typing


def flatten_dict(
    data: dict[str, dict], 
    prevNodes: typing.Optional[list[str]] = None, 
    flattened: typing.Optional[dict[str, str]] = None,
):
    if prevNodes is None:
        prevNodes = []
    if flattened is None:
        flattened = {}

    for key in data.keys():
        child = data.get(key)
        nodes = prevNodes.copy()
        nodes.append(key)
        if isinstance(child, str):
            flattened[".".join(nodes)] = child
        else:
            flatten_dict(child, nodes, flattened)    # type: ignore
            
    return flattened


                
def dict_from_nodes(prev_dict: dict, nodes: list[str], index: int, value: str):
    node = nodes[index]

    if index == len(nodes) - 1:
        prev_dict[node] = value
        return

    if prev_dict.get(node) is None:
        prev_dict[node] = {}
        
    dict_from_nodes(prev_dict[node], nodes, index + 1, value)


def inflate_dict(flattened_dict: dict[str, str]) -> dict:
    inflated_dict = {}
    for key, value in flattened_dict.items():
        nodes = key.split('.')
        dict_from_nodes(inflated_dict, nodes, 0, value)
    return inflated_dict