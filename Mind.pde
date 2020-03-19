import java.util.Set;
import java.util.HashSet;

class Mind {
  Set<Neuron> activatedNeurons;
  
  byte[][] neuronConnections;
  
  Neuron[] outputNeuron;
  double[] outputBias;
  Signal[] outputSignal;
  
  ArrayList<Neuron[]> hiddenNeuron;
  ArrayList<double[][]> hiddenWeight;
  ArrayList<double[]> hiddenBias;
  
  Neuron[] inputNeuron;
  double[][] inputWeight;
  double[] inputBias;
  
  JSONArray neuronStructure;
  
  Mind(JSONArray structure) {
    this(structure, 0);
  }
  Mind(JSONArray structure, double mutationRate) {
    boolean mutate = mutationRate > 0.000001;
    
    JSONObject inputData = structure.getJSONObject(0);
    JSONObject hiddenData = structure.getJSONObject(1);
    JSONObject outputData = structure.getJSONObject(2);
    
    int inpCount = inputData.getInt("input_count");
    
    int layerCount = hiddenData.getInt("layer_count");
    int[] hidLayers = new int[layerCount];
    for(int i = 0; i < layerCount; i++) {
      JSONObject l = hiddenData.getJSONObject("layer" + i);
      hidLayers[i] = l.getInt("hidden_count");
    }
    
    int outCount = outputData.getInt("output_count");
    
    double[] inpBias;
    double[][] inpWeights;
    double[] outBias;
    ArrayList<double[]> hidBias = new ArrayList<double[]>();
    ArrayList<double[][]> hidWeights = new ArrayList<double[][]>();
    if(!mutate) {
      inpBias = new double[inpCount];
      for(int i = 0; i < inpCount; i++) {
        JSONObject n = inputData.getJSONObject("input_neuron" + i);
        inpBias[i] = n.getDouble("bias");
      }
      int wc = inputData.getInt("weight_count");
      inpWeights = new double[inpCount][wc];
      for(int i = 0; i < inpCount; i++) {
        JSONObject n = inputData.getJSONObject("input_neuron" + i);
        for(int j = 0; j < wc; j++) {
          inpWeights[i][j] = n.getDouble("weight" + j);
        }
      }
      for(int l = 0; l < layerCount; l++) {
        int hc = hiddenData.getJSONObject("layer" + l).getInt("hidden_count");
        hidBias.add(l, new double[hc]);
        for(int i = 0; i < hc; i++) {
          JSONObject n = hiddenData.getJSONObject("layer" + l).getJSONObject("hidden_neuron" + i);
          hidBias.get(l)[i] = n.getDouble("bias");
        }
        int hwc = hiddenData.getJSONObject("layer" + l).getInt("weight_count");
        hidWeights.add(l, new double[hc][hwc]);
        for(int i = 0; i < hc; i++) {
          JSONObject n = hiddenData.getJSONObject("layer" + l).getJSONObject("hidden_neuron" + i);
          for(int j = 0; j < hwc; j++) {
            hidWeights.get(l)[i][j] = n.getDouble("weight" + j);
          }
        }
      }
      outBias = new double[outCount];
      for(int i = 0; i < outCount; i++) {
        JSONObject n = outputData.getJSONObject("output_neuron" + i);
        outBias[i] = n.getDouble("bias");
      }
    }
    else {
      inpBias = new double[inpCount];
      for(int i = 0; i < inpCount; i++) {
        JSONObject n = inputData.getJSONObject("input_neuron" + i);
        inpBias[i] = n.getDouble("bias") + random((float)-mutationRate, (float)mutationRate);
      }
      int wc = inputData.getInt("weight_count");
      inpWeights = new double[inpCount][wc];
      for(int i = 0; i < inpCount; i++) {
        JSONObject n = inputData.getJSONObject("input_neuron" + i);
        for(int j = 0; j < wc; j++) {
          inpWeights[i][j] = n.getDouble("weight" + j) + random((float)-mutationRate, (float)mutationRate);
        }
      }
      for(int l = 0; l < layerCount; l++) {
        int hc = hiddenData.getJSONObject("layer" + l).getInt("hidden_count");
        hidBias.add(l, new double[hc]);
        for(int i = 0; i < hc; i++) {
          JSONObject n = hiddenData.getJSONObject("layer" + l).getJSONObject("hidden_neuron" + i);
          hidBias.get(l)[i] = n.getDouble("bias") + random((float)-mutationRate, (float)mutationRate);
        }
        int hwc = hiddenData.getJSONObject("layer" + l).getInt("weight_count");
        hidWeights.add(l, new double[hc][hwc]);
        for(int i = 0; i < hc; i++) {
          JSONObject n = hiddenData.getJSONObject("layer" + l).getJSONObject("hidden_neuron" + i);
          for(int j = 0; j < hwc; j++) {
            hidWeights.get(l)[i][j] = n.getDouble("weight" + j) + random((float)-mutationRate, (float)mutationRate);
          }
        }
      }
      outBias = new double[outCount];
      for(int i = 0; i < outCount; i++) {
        JSONObject n = outputData.getJSONObject("output_neuron" + i);
        outBias[i] = n.getDouble("bias") + random((float)-mutationRate, (float)mutationRate);
      }
    }
    
    this.activatedNeurons = new HashSet<Neuron>();
    this.neuronStructure = new JSONArray();
    
    // Init
    this.outputSignal = new Signal[outCount];
    this.outputBias = outBias;
    this.outputNeuron = new Neuron[outCount];
    
    this.hiddenBias = hidBias;
    this.hiddenWeight = hidWeights;
    this.hiddenNeuron = new ArrayList<Neuron[]>();
    
    this.inputBias = inpBias;
    this.inputWeight = inpWeights;
    this.inputNeuron = new Neuron[inpCount];
    
    // Neuron Init
    // Output
    for(int i = 0; i < outCount; i++) {
      this.outputSignal[i] = new Signal();
      this.outputNeuron[i] = new OutputNeuron(this.outputSignal[i], this.outputBias[i]);
    }
    // Hidden
    for(int l = 0; l < hidLayers.length; l++) {
      if(l == 0) {
        this.hiddenNeuron.add(0, new Neuron[hidLayers[hidLayers.length - 1 - l]]);
        for(int i = 0; i < hidLayers[hidLayers.length - 1 - l]; i++) {
          this.hiddenNeuron.get(0)[i] = new TransportNeuron(this.outputNeuron, this.hiddenWeight.get(hidLayers.length - 1 - l)[i], this.hiddenBias.get(hidLayers.length - 1 - l)[i]);
        }
      }
      else {
        this.hiddenNeuron.add(0, new Neuron[hidLayers[hidLayers.length - 1 - l]]);
        for(int i = 0; i < hidLayers[hidLayers.length - 1 - l]; i++) {
          this.hiddenNeuron.get(0)[i] = new TransportNeuron(this.hiddenNeuron.get(1), this.hiddenWeight.get(hidLayers.length - 1 - l)[i], this.hiddenBias.get(hidLayers.length - 1 - l)[i]);
        }
      }
    }
    // Input
    for(int i = 0; i < inpCount; i++) {
      this.inputNeuron[i] = new InputNeuron(this.hiddenNeuron.get(0), this.inputWeight[i], this.inputBias[i]);
    }
  }
  
  Mind(int inputCount, int outputCount, int[] hiddenLayers) {
    this.activatedNeurons = new HashSet<Neuron>();
    this.neuronStructure = new JSONArray();
    
    // Output Init
    this.outputSignal = new Signal[outputCount];
    this.outputBias = new double[outputCount];
    this.outputNeuron = new Neuron[outputCount];
    for(int i = 0; i < outputCount; i++) {
      this.outputSignal[i] = new Signal();
      this.outputBias[i] = random(-2, 2);
      this.outputNeuron[i] = new OutputNeuron(this.outputSignal[i], this.outputBias[i]);
    }
    // Hidden Init
    this.hiddenBias = new ArrayList<double[]>();
    this.hiddenWeight = new ArrayList<double[][]>();
    this.hiddenNeuron = new ArrayList<Neuron[]>();
    for(int l = 0; l < hiddenLayers.length; l++) {
      if(l == 0) {
        this.hiddenBias.add(0, new double[hiddenLayers[hiddenLayers.length - 1 - l]]);
        this.hiddenWeight.add(0, new double[hiddenLayers[hiddenLayers.length - 1 - l]][outputCount]);
        this.hiddenNeuron.add(0, new Neuron[hiddenLayers[hiddenLayers.length - 1 - l]]);
        for(int i = 0; i < hiddenLayers[hiddenLayers.length - 1 - l]; i++) {
          for(int j = 0; j < outputCount; j++) {
            this.hiddenWeight.get(0)[i][j] = random(-2, 2);
          }
          this.hiddenBias.get(0)[i] = random(-2, 2);
          this.hiddenNeuron.get(0)[i] = new TransportNeuron(this.outputNeuron, this.hiddenWeight.get(0)[i], this.hiddenBias.get(0)[i]);
        }
      }
      else {
        this.hiddenBias.add(0, new double[hiddenLayers[hiddenLayers.length - 1 - l]]);
        this.hiddenWeight.add(0, new double[hiddenLayers[hiddenLayers.length - 1 - l]][hiddenLayers[hiddenLayers.length - l]]);
        this.hiddenNeuron.add(0, new Neuron[hiddenLayers[hiddenLayers.length - 1 - l]]);
        for(int i = 0; i < hiddenLayers[hiddenLayers.length - 1 - l]; i++) {
          for(int j = 0; j < hiddenLayers[hiddenLayers.length - l]; j++) {
            this.hiddenWeight.get(0)[i][j] = random(-2, 2);
          }
          this.hiddenBias.get(0)[i] = random(-2, 2);
          this.hiddenNeuron.get(0)[i] = new TransportNeuron(this.hiddenNeuron.get(1), this.hiddenWeight.get(0)[i], this.hiddenBias.get(0)[i]);
        }
      }
    }
    // Input Init
    this.inputBias = new double[inputCount];
    this.inputWeight = new double[inputCount][hiddenLayers[0]];
    this.inputNeuron = new Neuron[inputCount];
    for(int i = 0; i < inputCount; i++) {
      for(int j = 0; j < hiddenLayers[0]; j++) {
        this.inputWeight[i][j] = random(-2, 2);
      }
      this.inputBias[i] = random(-2, 2);
      this.inputNeuron[i] = new InputNeuron(this.hiddenNeuron.get(0), this.inputWeight[i], this.inputBias[i]);
    }  
  }
  
  void updateInput(int id) {
    this.updateInput(id, 1);
  }
  void updateInput(int id, double value) {
    if(id >= this.inputNeuron.length || id < 0) id = 0;
    this.inputNeuron[id].signal(value);
    this.inputNeuron[id].update(activatedNeurons);
  }
  
  double getOutput(int id) {
    if(id >= this.outputSignal.length || id < 0) id = 0;
    return this.outputSignal[id].getStrength();
  }
  
  void update() {
    if(this.activatedNeurons.size() > 0) {
      Set<Neuron> flow = new HashSet<Neuron>();
      for(Neuron n : activatedNeurons) {
        n.update(flow);
      }
      this.activatedNeurons = new HashSet<Neuron>(flow);
    }
  }
  
  private void updateNeuronStructure() {
    //Input structure
    JSONObject input = new JSONObject();
    input.setInt("input_count", this.inputNeuron.length);
    input.setInt("weight_count", this.inputNeuron[0].weights.length);
    for(int i = 0; i < this.inputNeuron.length; i++) {
      JSONObject neuron = new JSONObject();
      neuron.setDouble("bias", this.inputNeuron[i].getBias());
      for(int j = 0; j < this.inputNeuron[i].weights.length; j++) {
        neuron.setDouble("weight" + j, this.inputNeuron[i].weights[j]);
      }
      input.setJSONObject("input_neuron" + i, neuron);
    }
    //Hidden structure
    JSONObject hidden = new JSONObject();
    hidden.setInt("layer_count", this.hiddenNeuron.size());
    for(int l = 0; l < this.hiddenNeuron.size(); l++) {
      JSONObject layer = new JSONObject();
      layer.setInt("hidden_count", this.hiddenNeuron.get(l).length);
      layer.setInt("weight_count", this.hiddenNeuron.get(l)[0].weights.length);
      for(int i = 0; i < this.hiddenNeuron.get(l).length; i++) {
        JSONObject neuron = new JSONObject();
        neuron.setDouble("bias", this.hiddenNeuron.get(l)[i].bias);
        for(int j = 0; j < this.hiddenNeuron.get(l)[i].weights.length; j++) {
          neuron.setDouble("weight" + j, this.hiddenNeuron.get(l)[i].weights[j]);
        }
        layer.setJSONObject("hidden_neuron" + i, neuron);
      }
      hidden.setJSONObject("layer" + l, layer);
    }
    //Output structure
    JSONObject output = new JSONObject();
    output.setInt("output_count", this.outputNeuron.length);
    for(int i = 0; i < this.outputNeuron.length; i++) {
      JSONObject neuron = new JSONObject();
      neuron.setDouble("bias", this.outputNeuron[i].getBias());
      output.setJSONObject("output_neuron" + i, neuron);
    }
    
    this.neuronStructure = new JSONArray();
    this.neuronStructure.setJSONObject(0, input);
    this.neuronStructure.setJSONObject(1, hidden);
    this.neuronStructure.setJSONObject(2, output);
  }
  
  JSONArray getNeuronStructure() {
    this.updateNeuronStructure();
    return this.neuronStructure;
  }
}

class InputNeuron extends Neuron {
  InputNeuron(Neuron[] children, double[] weights, double bias) {
    super(NeuronType.INPUT, children, weights, bias);
  }
  
  @Override
  void update(Set<Neuron> updateArray) {
    double strength = 0;
    if(this.signals.size() > 0) {
      for(double f : signals) strength += f;
      strength = neuronFunction(1, strength/signals.size(), this.bias);
    }
    else strength = 1;
    for(int i = 0; i < connections.length; i++) {
      Neuron n = connections[i];
      double testStr = strength * this.weights[i];
      if(testStr > this.precision || testStr < -this.precision) {
        n.signal(testStr);
        if(!updateArray.contains(n)) updateArray.add(n);
      }
    }
    signals.clear();
  }
  @Override
  void signal(double strength) {
    this.signals.add(strength);
  }
}

class TransportNeuron extends Neuron {
  TransportNeuron(Neuron[] children, double[] weights, double bias) {
    super(NeuronType.TRANSPORT, children, weights, bias);
  }
  @Override
  void update(Set<Neuron> updateArray) {
    double strength = 0;
    for(double f : signals) strength += f;
    strength = neuronFunction(1, strength/signals.size(), this.bias);
    for(int i = 0; i < connections.length; i++) {
      Neuron n = connections[i];
      double testStr = strength * this.weights[i];
      if(testStr > this.precision || testStr < -this.precision) {
        n.signal(testStr);
        if(!updateArray.contains(n)) updateArray.add(n);
      }
    }
    signals.clear();
  }
  @Override
  void signal(double strength) {
    this.signals.add(strength);
  }
}

class OutputNeuron extends Neuron {
  Signal output;
  OutputNeuron(Signal out, double bias) {
    super(NeuronType.OUTPUT, null, null, bias);
    this.output = out;
  }
  @Override
  void update(Set<Neuron> updateArray) {
    double strength = 0;
    for(double f : signals) strength += f;
    strength = neuronFunction(1, strength/signals.size(), this.bias);
    if(strength > this.precision || strength < -this.precision) {
      this.output.setStrength(strength);
    }
    signals.clear();
  }
  @Override
  void signal(double strength) {
    this.signals.add(strength);
  }
}

abstract class Neuron {
  final double precision = 0.000001;
  double[] weights;
  Neuron[] connections;
  double bias;
  NeuronType type;
  ArrayList<Double> signals;
  Neuron(NeuronType neuronType, Neuron[] neurons, double[] neuronWeights, double biasValue) {
    this.type = neuronType;
    this.bias = biasValue;
    if(neurons != null) this.connections =  neurons;
    else this.connections = new Neuron[0];
    if(neuronWeights != null) this.weights = neuronWeights;
    else this.weights = new double[0];
    this.signals = new ArrayList<Double>();
  }
  abstract void update(Set<Neuron> updateArray);
  abstract void signal(double strength);
  NeuronType getType() {
    return this.type;
  }
  double getBias() {
    return this.bias;
  }
}

static enum NeuronType {
  TRANSPORT,
  INPUT,
  OUTPUT;
}

class Signal {
  double strength;
  void setStrength(double str) {
    this.strength = str;
  }
  double getStrength() {
    double ret = this.strength;
    this.strength = 0;
    return ret;
  }
}
